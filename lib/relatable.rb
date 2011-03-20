module Relatable
  module ClassMethods

    def acts_as_association(associations,relationship)
      self.class_eval( "has_many \"#{associations.to_sym}\", :as => \"#{(relationship[:as].to_sym)}\"" )
    end

    def belongs_to_association(relationships)

      (sourcable,targetable)  = relationships[:sourcable],relationships[:targetable]

      self.class_eval( "belongs_to \"#{sourcable}\", :polymorphic => true\n
                        belongs_to \"#{targetable}\", :polymorphic => true" )
    end
  end
  
  def instance_acts_as(associations,relationships)
      relationship          = relationships[:as].to_sym

      eigenclass.class_eval do

          define_method(("#{associations}").to_sym) do |a|
            a_namified = a.class.to_s.underscore.pluralize

            self.save 

            eigenclass.class_eval do 

              define_method(a_namified) do
                begin
                  e.send(:remove_method,a_namified)
                rescue
                  a.class.send(:where,(relationship.to_s + "_id").to_sym => self.id, (relationship.to_s + "_type").to_sym => self.class ) 
                end
              end
            end

            a.send("#{ (relationship.to_s + "_id=").to_sym }",self.id)
            a.send("#{ (relationship.to_s + "_type=").to_sym}",self.class.to_s)
            a.send("#{ (relationship.to_s + "_action=").to_sym}",associations.to_s)
            a.save 

          end
      end

  end

  def eigenclass
    class << self
      self
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

end
