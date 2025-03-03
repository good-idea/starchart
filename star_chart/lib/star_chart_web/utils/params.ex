defmodule StarChartWeb.Utils.Params do
  @moduledoc """
  Utility functions for parsing and validating request parameters.
  """

  @doc """
  Parses a string parameter into an integer.
  
  ## Parameters
    - params: The params map from the request
    - key: The key to look up in the params map
    - default: The default value to use if the parameter is missing or invalid
    
  ## Examples
      iex> parse_int_param(%{"page" => "5"}, "page", 1)
      5
      
      iex> parse_int_param(%{"page" => "invalid"}, "page", 1)
      1
      
      iex> parse_int_param(%{}, "page", 1)
      1
  """
  def parse_int_param(params, key, default) do
    with {:ok, value} <- Map.fetch(params, key),
         {int_value, ""} <- Integer.parse(value) do
      int_value
    else
      _ -> default
    end
  end

  @doc """
  Validates parameters against a schema of validation rules.
  
  ## Parameters
    - params: The params map from the request
    - schema: A map of parameter keys to validation rules
  
  ## Validation Rules
    For numeric parameters:
      %{type: :integer, min: 1, max: 200, default: 1}
    
    For string parameters:
      %{type: :string, max_length: 100, default: ""}
  
  ## Returns
    - {:ok, validated_params} if all validations pass
    - {:error, {key, error_message}} if any validation fails
  
  ## Examples
      iex> validate_params(%{"page" => "5", "name" => "test"}, %{
      ...>   "page" => %{type: :integer, min: 1, max: 10, default: 1},
      ...>   "name" => %{type: :string, max_length: 50, default: ""}
      ...> })
      {:ok, %{"page" => 5, "name" => "test"}}
      
      iex> validate_params(%{"page" => "15"}, %{
      ...>   "page" => %{type: :integer, min: 1, max: 10, default: 1}
      ...> })
      {:error, {"page", "must be less than or equal to 10"}}
  """
  def validate_params(params, schema) do
    Enum.reduce_while(schema, {:ok, %{}}, fn {key, validation}, {:ok, acc} ->
      case validate_param(params, key, validation) do
        {:ok, {key, value}} -> {:cont, {:ok, Map.put(acc, key, value)}}
        {:error, message} -> {:halt, {:error, {key, message}}}
      end
    end)
  end

  defp validate_param(params, key, %{type: :integer} = validation) do
    default = Map.get(validation, :default)
    
    case parse_int_param(params, key, default) do
      nil when is_nil(default) ->
        if Map.has_key?(params, key) do
          {:error, "must be a valid integer"}
        else
          {:ok, {key, nil}}
        end
        
      value when is_integer(value) ->
        min = Map.get(validation, :min)
        max = Map.get(validation, :max)
        
        cond do
          not is_nil(min) and value < min ->
            {:error, "must be greater than or equal to #{min}"}
            
          not is_nil(max) and value > max ->
            {:error, "must be less than or equal to #{max}"}
            
          true ->
            {:ok, {key, value}}
        end
        
      _ ->
        {:error, "must be a valid integer"}
    end
  end

  defp validate_param(params, key, %{type: :string} = validation) do
    default = Map.get(validation, :default, "")
    value = Map.get(params, key, default)
    
    if is_binary(value) do
      max_length = Map.get(validation, :max_length)
      
      if is_nil(max_length) or String.length(value) <= max_length do
        {:ok, {key, value}}
      else
        {:error, "must be at most #{max_length} characters long"}
      end
    else
      {:error, "must be a string"}
    end
  end
end
