local function tosticker(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local file = 'sticker.webp'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    send_document(get_receiver(msg), file, ok_cb, false)
	send_large_msg(receiver, 'ذخیره شد', ok_cb, false)
    redis:del("photo:setsticker")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'خطا لطفا مجددا سعی نمایید', ok_cb, false)
  end
end
local function run(msg,matches)
    local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.media then
       if msg.media.type == 'photo' and redis:get("photo:setsticker") then
        if redis:get("photo:setsticker") == 'waiting' then
          load_photo(msg.id, tosticker, msg)
        end
       end
    end
    if matches[1]:lower() == "setsticker" and is_sudo(msg) then
     redis:set("photo:setsticker", "waiting")
     return 'لطفا حالا استیکر را ارسال نمایید'
    end
	if matches[1]:lower() == 'sticker' then --[[Your bot name]]
	send_document(get_receiver(msg), "sticker.webp", ok_cb, false)
end
end
return {
  patterns = {
 "^[!/#](setsticker)$",
 "^(sticker)$",
 "^[!#/]([Ss]ticker)$",
 "%[(photo)%]",
  },
  run = run,
}
