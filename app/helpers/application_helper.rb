module ApplicationHelper
    include Pagy::Frontend
    Pagy::DEFAULT[:items] = 8
end