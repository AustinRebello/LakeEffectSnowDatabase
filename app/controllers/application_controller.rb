class ApplicationController < ActionController::Base
    def not_found(exception = nil)
        if exception
            logger.info "Rendering 404: #{exception.message}"
        end
      
        redirect_to home_404_url
      end
end
