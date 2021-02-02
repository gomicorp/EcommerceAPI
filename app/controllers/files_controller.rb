class FilesController < ApiController
  before_action :set_record, except: %i[destroy]

  def show
  end

  def create
    if @record.update(attribute_name => blob_file)
      render json: nil, status: :ok
    else
      render json: nil, status: :unprocessable_entity
    end
  end

  def destroy
    if ActiveStorage::Attachment.find(params[:id]).destroy
      render json: 'deleted', status: :ok
    else
      render json: 'failed', status: :unprocessable_entity
    end
  end

  private

  def file_params
    params.permit(:name, :record_type, :record_id, :blob)
  end

  def set_record
    @record = model_name.find(record_id)
  end

  def model_name
    file_params[:record_type].constantize
  end

  def record_id
    file_params[:record_id]
  end

  def attribute_name
    file_params[:name]
  end

  def blob_file
    file_params[:blob]
  end
end
