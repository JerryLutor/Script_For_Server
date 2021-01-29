-- Scheduling inputs for Astra 5.62 and newer
--
-- In the web interface create new stream
-- Remember stream ID. In this example stream ID is a001
-- Save this script to /etc/astra/mod/schedule.lua
-- Write your own time map
control_api["set-input"] = function(server, client, request)
    local channel_data = channel_list_ID[request.id]
        local input_id = tonumber(request.input)
            channel_init_input(channel_data, input_id)
                for i,d in ipairs(channel_data.input) do
                        if d.input and i ~= input_id then
                                    channel_kill_input(channel_data, i)
                                                log.debug("[" .. channel_data.config.name .. "] Destroy input #" .. i)
                                                        end
                                                            end
                                                                control_api_response(server, client, { ["set-input"] = "ok" })
                                                                end