-- name = "News"
-- description = "Simple news widget"
-- data_source = "https://rss-to-json-serverless-api.vercel.app/"
-- type = "widget"
-- author = "Andrey Gavrilov"
-- version = "1.0"

-- settings
local feed = "https://news.yandex.ru/index.rss"
local lines_num = 5
local auto_folding = false

local api_url = "https://rss-to-json-serverless-api.vercel.app/api?feedURL="
local titles = {}
local descs = {}
local urls = {}
local times = {}
local url = ""

local json = require "json"

function on_resume()
    if auto_folding then
        ui:set_folding_flag(true)
        ui:show_lines(titles)
    end
end

function on_alarm()
    http:get(api_url..feed)
end

function on_network_result(result)
    local t = json.decode(result)
    local n = aio:get_args()[2]
    n = math.min(lines_num, #t.items)
    
    for i = 1, n, 1 do
        titles[i] = t.items[i].title
        descs[i] = t.items[i].description
        urls[i] = t.items[i].url
        times[i] = os.date("%d.%m.%Y, %H:%M",t.items[i].created/1000)
    end
    
    ui:show_lines(titles)
end

function on_click(i)
    url = urls[i]
    ui:show_dialog(titles[i].." | "..times[i], descs[i], "Open in browser")
end

function on_dialog_action(i)
    if i == 1 then
        system:open_browser(url)
    end
end
