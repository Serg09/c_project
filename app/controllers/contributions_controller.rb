class ContributionsController < ApplicationController
  before_filter :authenticate_user!, only: [:index, :show]
  before_filter :load_campaign, only: [:index, :new, :create]
  before_filter :load_contribution, only: [:show, :edit, :update, :reward, :set_reward, :payment, :pay]
  before_filter :validate_state!, only: [:reward, :set_reward, :payment, :pay]
  before_filter :load_reward, only: [:create, :edit, :update, :reward, :set_reward, :pay, :payment]

  respond_to :html

  def index
    authorize! :update, @campaign
  end

  def show
    authorize! :show, @contribution
  end

  def new
    @contribution = @campaign.contributions.new
    @fulfillment = PhysicalFulfillment.new # TODO Need physical or electronic here
  end

  def create
    @contribution = @campaign.contributions.new contribution_params
    if @contribution.save
      redirect_to create_or_edit_redirect_path
    else
      render :new
    end
  end

  def edit
    @fulfillment = @contribution.build_fulfillment(reward_id: @reward.try(:id))
  end

  def update
    @contribution.update_attributes contribution_params
    if @contribution.save
      redirect_to create_or_edit_redirect_path
    else
      render :edit
    end
  end

  def reward
  end

  def set_reward
    redirect_to payment_contribution_path(@contribution, reward_id: selected_reward_id)
  end

  def payment
    if @reward
      @fulfillment = @contribution.build_fulfillment(reward_id: @reward.id)
      @shipping_address_same = true
      if @reward.minimum_contribution == @contribution.amount
        @back_path = edit_contribution_path(@contribution, reward_id: @reward.id)
        @back_title = 'Click here to select a different contribution amount.'
      else
        @back_path = reward_contribution_path(@contribution, reward_id: @reward.id)
        @back_title = 'Click here to select a different reward.'
      end
    else
      @back_path = edit_contribution_path(@contribution)
      @back_title = 'Click here to select a different contribution amount.'
    end
    @payment = @contribution.payments.new billing_country_code: 'US'
  end

  def pay
    @contribution.update_attributes contribution_params
    @payment = @contribution.payments.new payment_params
    @fulfillment = build_fulfillment
    if @contribution.save
      if @fulfillment.nil? || @fulfillment.save
        if @payment.save && @contribution.collect!
          send_notification_emails
          redirect_to book_path(@campaign.book_id), notice: 'Your contribution has been saved successfully. Expect to receive a confirmation email with all of the details.'
        else
          logger.debug "Unable to process the payment #{@payment.inspect}: #{@payment.errors.full_messages.to_sentence}"
          flash[:alert] = "Unable to process the payment."
          render :payment
        end
      else
        logger.debug "Unable to save the fulfillment #{@fulfillment.inspect}: #{@fulfillment.errors.full_messages.to_sentence}"
        flash[:alert] = "Unable to save the fulfillment."
        render :payment
      end
    else
      logger.debug "Unable to save the contributions #{@contribution.inspect}: #{@contribution.errors.full_messages.to_sentence}, payment errors: #{@payment.errors.full_messages.to_sentence}"
      flash[:alert] = "Unable to save the contribution."
      render :payment
    end
  end

  private

  def build_fulfillment
    if @reward.nil?
      nil
    elsif @reward.physical_address_required?
      PhysicalFulfillment.new physical_fulfillment_params
    else
      ElectronicFulfillment.new electronic_fulfillment_params
    end
  end

  def create_or_edit_redirect_path
    if @reward
      payment_contribution_path(@contribution, reward_id: @reward.id)
    elsif @campaign.rewards.none?
      payment_contribution_path(@contribution)
    else
      reward_contribution_path(@contribution)
    end
  end

  def physical_fulfillment_params
    params.require(:fulfillment).permit(
      :reward_id,
      :first_name,
      :last_name,
      :address1,
      :address2,
      :city,
      :state,
      :postal_code
    ). merge(contribution: @contribution,
             first_name: @payment.first_name,
             last_name: @payment.last_name,
             country_code: 'US').tap do |h|
               if params[:shipping_address_same] == '1'
                 h.merge! address1: @payment.billing_address_1,
                          address2: @payment.billing_address_2,
                          city: @payment.billing_city,
                          state: @payment.billing_state,
                          postal_code: @payment.billing_postal_code,
                          country_code: @payment.billing_country_code
               end
             end
  end

  def electronic_fulfillment_params
    params.require(:fulfillment).permit(
      :reward_id
    ).merge(contribution: @contribution,
            email: @contribution.email,
            first_name: @payment.first_name,
            last_name: @payment.last_name)
  end

  def payment_params
    params.require(:payment).permit(
      :credit_card_number,
      :credit_card_type,
      :expiration_month,
      :expiration_year,
      :cvv,
      :first_name,
      :last_name,
      :billing_address_1,
      :billing_address_2,
      :billing_city,
      :billing_state,
      :billing_postal_code
    ).merge(billing_country_code: 'US')
  end

  def contribution_params
    {
      ip_address: request.remote_ip,
      user_agent: request.headers['HTTP_USER_AGENT']
    }.with_indifferent_access.tap do |h|
      if params[:contribution].present?
        h.merge! params.require(:contribution).permit(:amount, :email)
      end
      if @reward.present?
        h[:amount] = @reward.minimum_contribution
      end
    end
  end

  def load_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def load_contribution
    @contribution = Contribution.find(params[:id])
    @campaign = @contribution.campaign
  end

  def load_reward
    @reward = Reward.find(selected_reward_id) if selected_reward_id.present?
  end

  def send_notification_emails
    # TODO Move this to resque jobs
    ContributionMailer.contribution_receipt(@contribution).deliver_now
    ContributionMailer.contribution_received_notify_author(@contribution).deliver_now unless @contribution.campaign.author.unsubscribed?
    AdminMailer.contribution_received(@contribution).deliver_now
    if campaign_just_succeeded?
      CampaignMailer.succeeded(@contribution.campaign).deliver_now unless @contribution.campaign.author.unsubscribed?
      AdminMailer.campaign_succeeded(@contribution.campaign).deliver_now
      @contribution.campaign.success_notification_sent_at = DateTime.now
      @contribution.campaign.save!
    end
  end

  def campaign_just_succeeded?
    @campaign.target_amount_reached? && !@campaign.success_notification_sent?
  end

  def set_error_flash
    if Rails.env.production?
      flash.now[:alert] = 'We were unable to save your contribution. Please try again later.'
    else
      flash.now[:alert] = "We were unable to save your contribution. #{@contribution_creator.exceptions.to_sentence}"
    end
  end

  def selected_reward_id
    @selected_reward_id ||= params[:fulfillment].try(:[], :reward_id) || params[:reward_id]
  end

  def validate_state!
    unless @contribution.incipient?
      redirect_to user_root_path, alert: "The specified contribution cannot be modified"
    end
  end
end