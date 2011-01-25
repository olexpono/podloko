pusher_info = YAML.load_file(Rails.root.join("config/pusher.yml"))[Rails.env]

Pusher.app_id = pusher_info["app_id"]
Pusher.key = pusher_info["key"]
Pusher.secret = pusher_info["secret"]
