class AdjustFulfillmentRecipient < ActiveRecord::Migration
  def up
    add_column :fulfillments, :recipient, :string, limit: 100
    ActiveRecord::Base.connection.execute <<-SQL
      update fulfillments set
        recipient = first_name || ' ' || last_name;
    SQL
    remove_column :fulfillments, :first_name
    remove_column :fulfillments, :last_name
  end

  def down
    add_column :fulfillments, :first_name, :string, limit: 100
    add_column :fulfillments, :last_name, :string, limit: 100
    ActiveRecord::Base.connection.execute <<-SQL
      update fulfillments set
        first_name = substring(recipient from 1 for position(' ' in recipient)-1),
        last_name = substring(recipient from position(' ' in recipient)+1)
    SQL
    remove_column :fulfillments, :recipient
  end
end
