# frozen_string_literal: true

class DirectUploadController < ApplicationController
  def create
    puts "params: #{params}"
    blob = ActiveStorage::Blob.create_and_upload!(
      io: params['file'],
      filename: 'foto_post'
    )
    url_upload = blob.service_url_for_direct_upload
    url_blob = url_upload.split('?')[0]
    render json: { url: url_blob, blob_signed_id: blob.signed_id }
  end
end
