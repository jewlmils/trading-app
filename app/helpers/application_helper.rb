module ApplicationHelper
    include Pagy::Frontend
    Pagy::DEFAULT[:items] = 7
end