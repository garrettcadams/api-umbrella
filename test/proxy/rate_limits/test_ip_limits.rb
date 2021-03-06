require_relative "../../test_helper"

class Test::Proxy::RateLimits::TestIpLimits < Minitest::Test
  include ApiUmbrellaTestHelpers::Setup
  include ApiUmbrellaTestHelpers::RateLimits
  include Minitest::Hooks

  def setup
    setup_server
    once_per_class_setup do
      override_config_set({
        :apiSettings => {
          :rate_limits => [
            {
              :duration => 60 * 60 * 1000, # 1 hour
              :accuracy => 1 * 60 * 1000, # 1 minute
              :limit_by => "ip",
              :limit => 5,
              :distributed => true,
              :response_headers => true,
            },
          ],
        },
      }, "--router")
    end
  end

  def after_all
    super
    override_config_reset("--router")
  end

  def test_ip_rate_limit
    assert_ip_rate_limit("/api/hello", 5)
  end
end
