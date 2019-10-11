class GraphqlController < ApplicationController
  before_action :authenticate!, unless: :is_public

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    Current.user = current_user
    Current.ip_address = request.ip
    context = {
      # Query context goes here, for example:
      current_user: current_user
    }
    result = GehnaSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue => e
    raise e unless Rails.env.development?
    handle_error_in_development e
  end

  def authenticate!
    raise Exceptions::Unauthorized.new("Access token invalid") unless current_user
  end

  def current_user
    # find token. Check if valid.
    if request.headers['Authorization']
      api_key = ApiKey.valid.find_by(access_token: request.headers['Authorization'])
      return false unless api_key.present?
      @current_user = api_key.keyable
      # @current_user.update_last_login unless @current_user.was_just_active?
      @current_user
    else
      false
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: 'RecordNotFound', message: e.message }, status: 404
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: {error: 'RecordInvalid', message: e.record.errors.full_messages.join }, status: 422
  end

  rescue_from ActiveRecord::StatementInvalid do |e|
    render json: {error: 'StatementInvalid', message: e.message }, status: 422
  end

  rescue_from ActiveRecord::RecordNotUnique do |e|
    render json: {error: 'RecordNotUnique', message: e.message }, status: 422
  end

  rescue_from Exceptions::Unauthorized do |e|
    render json: {error: 'Unauthorized', message: e.message}, status: 401
  end
  
  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { error: { message: e.message, backtrace: e.backtrace }, data: {} }, status: 500
  end

  def is_public
    parsed_query = GraphQL::Query.new GehnaSchema, params[:query]
    if parsed_query.selected_operation.present?
      operation = parsed_query.selected_operation.selections.first.name
      return true if operation == '__schema'
      field = GehnaSchema.query.get_field(operation) || GehnaSchema.mutation.get_field(operation)
      return true if field && field.metadata[:is_public] == true
      false
    else
      raise ArgumentError, "Invalid input or no selections made on returning objects."
    end
  end
end

