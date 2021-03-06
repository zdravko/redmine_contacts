class Deal < ActiveRecord::Base  
  unloadable
  set_table_name "rc_deals"
  
  STATUS_PENDING     = 0
  STATUS_WON         = 1
  STATUS_LOST        = 2
  
  STATUSES = { STATUS_PENDING =>     { :name => :label_deal_pending, :sym_name => :label_deal_pending, :color => 'darkgrey', :order => 1, :sym => STATUS_PENDING },
            STATUS_WON =>  { :name => :label_deal_won, :sym_name => :label_deal_won, :color => 'green', :order => 2, :sym => STATUS_WON },
            STATUS_LOST =>  { :name => :label_deal_lost, :sym_name => :label_deal_lost, :color => 'red', :order => 3, :sym => STATUS_LOST }
              }.freeze
  
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_many :notes, :as => :source, :dependent => :delete_all, :order => "created_on DESC"
  belongs_to :assigned_to, :class_name => 'User', :foreign_key => 'assigned_to_id'    

  has_and_belongs_to_many :contacts, :order => "#{Contact.table_name}.last_name, #{Contact.table_name}.first_name"                 
 
 
  acts_as_watchable

  acts_as_attachable :view_permission => :view_deals,
                     :delete_permission => :delete_deals

  validates_presence_of :name   
  validates_numericality_of :price, :allow_nil => true    
  
  def visible?(usr=nil)
    usr ||= User.current
    usr.allowed_to_globally?(:view_deals, {})
  end  
  
  def status
    l(STATUSES[self.status_id][:name])
  end
  

end
