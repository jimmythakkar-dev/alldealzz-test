if @my_review.present?
  json.my_review do
    json.review_id @my_review.id
    json.review_text @my_review.message
    json.rating @my_review.rating.to_i
  end
else
  json.my_review nil
end