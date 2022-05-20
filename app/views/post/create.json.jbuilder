json.extract! @post,:id, :title, :created_at, :updated_at, :user_id
json.img @post.photo.url