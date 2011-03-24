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
 
  # TODO: The construction of the Association within the instance creates an issue with self-referential relationships:
  #  For example:
  #   e = Email.new
  #   e.behaves_like :drops, ... etc.
  #   ...Now how does e refer to itself if it does something to itself?  A couple of ways to solve this:
  #      1. Create a self-reflection method.
  #      2. Provide the original behavior in the master branch s.t. e.drops a, where 'a' is an 'Association'
  #
  #   Perhaps the way to handle this is:
  #      if related_model is self, then alter related_model s.t. a self-reference can be made:  e.g., e.drops e, the "e" being dropped is self, and can be checked for.
  #      related_model can be altered
  #      whether or not e can drop e is verified by self.can_drop?(e) 
 
  def behaves_like(action,relationships)
      @action, @inverse_action, @relationship, @association_table = action.to_sym, relationships[:inverse].to_sym, relationships[:as].to_sym, relationships[:via]


      #Enter eigenclass to define singletons
      eigenclass.class_eval do

          #Define a 'can_<action>?' singleton:
          #  
          # iff @action => :drops, for e, then e.can_drop? will be defined.
          #   e.can_drop?(p) in this case, e and p actions must be relatable, the relationship and inverse relationship must match, and they must share an association table.

          define_method( ("can_#{action.to_s.singularize}?").to_sym ) do |related_model|
            begin
              ( related_model.instance_variable_get(:@inverse_action)     == @action ) &&             
              ( related_model.instance_variable_get(:@relationship)       == inverse_as(@relationship) ) &&          
              ( related_model.instance_variable_get(:@association_table)  == @association_table ) #self.instance_variable_get(:@association_table) )            
            rescue
              raise "Action relationship is undefined."
            end
          end

          define_method(("#{action}").to_sym) do |related_model|

            #guards
            #can source actually operate on related_model?


            #Behavior here s.t. a new association is created for each action:
            #
            #  e.behaves_like :drops ...
            #  p.behaves_like :receives ...
            #
            #  e.drops p <--- new association instance is created.
            #  e.drops p <--- another new association instance.

            association_name      = @association_table.to_s.underscore.pluralize
            association_instance  = @association_table.new

            #self.save #perhaps unnecessary

            eigenclass.class_eval do 

              define_method(action.to_s) do
                begin
                  e.send(:remove_method,association_name) #the method may already be defined.  accounts for change in relationship (e.g., :sourcable to :targetable
                rescue
                  a.class.send(:where,(@relationship.to_s + "_id").to_sym => self.id, (@relationship.to_s + "_type").to_sym => self.class ) 
                end
              end
            end

            #Does a respond?
            association_instance.send("#{ (@relationship.to_s + "_id=").to_sym }",self.id)
            association_instance.send("#{ (@relationship.to_s + "_type=").to_sym}",self.class.to_s)
            association_instance.send("#{ (@relationship.to_s + "_action=").to_sym}",action.to_s)

            association_instance.save #perhaps unnecessary

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

  def is_association_table?(constant)

  end


  def inverse_as(action)
    action == :sourcable ? :targetable : :sourcable
  end

end
