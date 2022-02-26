json.extract! report, :id, :title, :content, :created_at, :updated_at
json.url report_url(report, format: :json)
