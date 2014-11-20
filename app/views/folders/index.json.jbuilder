json.array!(@folders) do |folder|
  json.extract! folder, :id
  json.url folder_url(folder, format: :json)
end
