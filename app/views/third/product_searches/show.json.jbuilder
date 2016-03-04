json.array! @results do |r|
  json.name r['Name']
  json.description r['Description']
  json.image r['Image']
  json.url r['Url']
end