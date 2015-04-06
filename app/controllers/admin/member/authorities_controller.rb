module Admin
  module Member
    class AuthoritiesController < ApplicationController
      before_action :authenticate_user!
      def show
      end
      def update
      end
    end
  end
end
