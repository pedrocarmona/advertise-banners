FactoryGirl.define do
  factory :campaign do
    transient do
        banner_count   1
        clicks_count_of_each_banner    1
        revenue_of_each_click 0.1
    end

    trait :with_banner do
        after(:create) do |instance, evaluator|
            create_list :banner, evaluator.banner_count, campaign: instance
        end
    end

    trait :with_banner_and_clicks do
        after(:create) do |instance, evaluator|
            create_list :banner, evaluator.banner_count, :with_clicks, campaign: instance, clicks_count: evaluator.clicks_count_of_each_banner, revenue_of_each_click: evaluator.revenue_of_each_click
        end
    end
  end

  factory :banner do
    campaign
    transient do
        clicks_count  1
        revenue_of_each_click 0.1
    end
    trait :with_clicks do
        after(:create) do |instance, evaluator|
            create_list :click, evaluator.clicks_count, :with_conversion, banner: instance, revenue_of_each_click: evaluator.revenue_of_each_click
        end
    end
  end

  factory :click do
    banner
    transient do
        revenue_of_each_click 0.1
    end
    trait :with_conversion do
      after(:create) do |instance, evaluator|
        create :conversion, click: instance, revenue: evaluator.revenue_of_each_click
      end
    end
  end

  factory :conversion do
    click
    revenue 0.1
  end

end
