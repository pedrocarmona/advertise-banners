FactoryGirl.define do
  factory :campaign do
    transient do
        banner_with_profit_count   1
        min_clicks_banner_with_profit 1
        max_clicks_banner_with_profit 3
        min_click_revenue_banner_with_profit 0.1
        max_click_revenue_banner_with_profit 3.0

        banner_with_clicks_count   1
        min_clicks_banner_with_clicks 1
        max_clicks_banner_with_clicks 5

        banner_without_clicks_count 1

    end

    trait :with_banners_of_several_types do
        after(:create) do |instance, evaluator|
            create_list :banner, evaluator.banner_with_profit_count, :with_clicks,
            campaign: instance,  min_clicks: evaluator.min_clicks_banner_with_profit,
            max_clicks: evaluator.max_clicks_banner_with_profit,
            min_click_revenue: evaluator.min_click_revenue_banner_with_profit,
            max_click_revenue: evaluator.max_click_revenue_banner_with_profit
        end
        after(:create) do |instance, evaluator|
            create_list :banner, evaluator.banner_with_clicks_count, :with_clicks,
            campaign: instance, min_clicks: evaluator.min_clicks_banner_with_clicks,
            max_clicks: evaluator.max_clicks_banner_with_clicks
        end
        after(:create) do |instance, evaluator|
            create_list :banner, evaluator.banner_without_clicks_count,
            campaign: instance
        end
    end
  end

  factory :banner do
    campaign
    transient do
        min_clicks 1
        max_clicks 1
        min_click_revenue 0.0
        max_click_revenue 0.0
    end

    trait :with_clicks do
        after(:create) do |instance, evaluator|
            create_list :click, rand(evaluator.min_clicks .. evaluator.max_clicks),
             :with_conversion, banner: instance, min_click_revenue: evaluator.min_click_revenue,
             max_click_revenue: evaluator.max_click_revenue
        end
    end
  end

  factory :click do
    banner
    transient do
        min_click_revenue 0.0
        max_click_revenue 0.0
    end
    trait :with_conversion do
      after(:create) do |instance, evaluator|
        create :conversion, click: instance,
          revenue: rand( evaluator.min_click_revenue .. evaluator.max_click_revenue)
      end
    end
  end

  factory :conversion do
    click
    revenue 0.0
  end


end
