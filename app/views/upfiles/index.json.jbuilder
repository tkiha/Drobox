json.array!(@upfiles) do |upfile|
  json.extract! upfile, :id
  json.url upfile_url(upfile, format: :json)
end
