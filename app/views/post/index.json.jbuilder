json.array! @posts.each do |post|
  json.title post.title
  json.img post.photo.url
end