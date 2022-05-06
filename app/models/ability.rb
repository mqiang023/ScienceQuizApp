class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role? :admin 
      # Admin can do all
      can :manage, :all

    elsif user.role? :leader
      # Leader can read everything
      can :read, :all

      # Leader can create User, Team, and StudentTeam
      can :create, User
      can :create, Team
      can :create, StudentTeam

      # Leader can modify their own Organization
      can :modify, Organization do |this_org|  
        this_org == user.organization
      end

      # Leader can modify Users from their Organization
      can :modify, User do |this_user|  
        this_user.organization == user.organization
      end

      # Leader can modify Team from their Organization
      can :modify, Team do |this_team|  
        this_team.organization == user.organization
      end

      # Leader can modify StudentTeam from their Organization
      can :modify, StudentTeam do |this_stu_team|  
        this_stu_team.student.organization == user.organization
      end

    elsif user.role? :coach

      # Coach can index Team, Student, Organization, Event, and Quiz
      can :index, Team
      can :index, Student
      can :index, Organization
      can :index, Event
      can :index, Quiz

      # Coach can show all Quiz and Event
      can :show, Quiz
      can :show, Event

      # Coach can show their own Organization
      can :show, Organization do |this_org|  
        this_org == user.organization
      end
      
      # Coach can show Students from their Organization
      can :show, Student do |this_stu|  
        this_stu.organization == user.organization
      end

      # Coach can modify active Students from their Organization
      can :modify, Student do |this_stu|  
        (this_stu.organization == user.organization) && (this_stu.active == true)
      end

      # Coach can update StudentTeam from their Organization
      can :update, StudentTeam do |this_stu_team|  
        this_stu_team.student.organization == user.organization
      end

    end
    
  end
end
