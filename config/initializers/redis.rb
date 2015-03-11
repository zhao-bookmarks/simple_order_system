
$count_redis = Redis::Namespace.new(:count, :redis => Redis.new)
$publish_redis = Redis.new
