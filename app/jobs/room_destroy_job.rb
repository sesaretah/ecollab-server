class RoomDestroyJob < ApplicationJob
  queue_as :default
  URL = 'https://kaarafarinan.ir:8089/janus'

  def perform(room_id, secret)
    room = Room.find_by_id(room_id)
    opts = {
    headers: {
      'Authorization' => "",
      'Content-Type' => 'application/json'
    },
    body: {     
        "janus" => "create",
        "transaction" => SecureRandom.hex(10)
      }.to_json
    }
    session = HTTParty.post(URL, opts)
    
    opts = {
      headers: {
        'Authorization' => "",
        'Content-Type' => 'application/json'
      },
      body: {     
          "janus" => "attach",
          "plugin" => "janus.plugin.videoroom",
          "transaction" => SecureRandom.hex(10)
        }.to_json
      }
      plugin = HTTParty.post(URL+'/'+session['data']['id'].to_s, opts)

      opts = {
        headers: {
          'Authorization' => "",
          'Content-Type' => 'application/json'
        },
        body: {     
            "janus" => "message",
            "transaction" => SecureRandom.hex(10),
            "body" => {
              "request" => "destroy", 
              "room" => room_id.to_i,
              "secret" => secret,
              "permanent" => true,
            }
          }.to_json
        }
      janus_room = HTTParty.post(URL+'/'+session['data']['id'].to_s+'/'+plugin['data']['id'].to_s, opts)
      if janus_room["janus"] && janus_room["janus"] == "success"
        room.activated = false
        room.save
      end
  end
end
