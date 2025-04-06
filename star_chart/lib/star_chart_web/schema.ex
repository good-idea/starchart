defmodule StarChartWeb.Schema do
  @moduledoc """
  OpenAPI schemas for the Star Chart API.
  """

  # --------------------------------------------------------------------
  # Schema for a Star
  # --------------------------------------------------------------------
  defmodule Star do
    @moduledoc "Represents a star."
    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      title: "Star",
      description: "A star object",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Unique identifier for the star"},
        name: %Schema{type: :string, description: "Name of the star"},
        proper_name: %Schema{
          type: :string,
          nullable: true,
          description: "Proper name of the star"
        },
        is_primary: %Schema{
          type: :boolean,
          description: "Indicates if the star is the primary star in its system"
        },
        hip: %Schema{type: :integer, nullable: true, description: "Hipparcos catalog number"},
        hd: %Schema{type: :string, nullable: true, description: "HD catalog number"},
        hr: %Schema{type: :string, nullable: true, description: "HR catalog number"},
        gl: %Schema{type: :string, nullable: true, description: "GL catalog number"},
        bayer_flamsteed: %Schema{
          type: :string,
          nullable: true,
          description: "Bayer or Flamsteed designation"
        },
        right_ascension: %Schema{
          type: :number,
          format: :float,
          nullable: true,
          description: "Right ascension"
        },
        right_ascension_degrees: %Schema{
          type: :number,
          format: :float,
          nullable: true,
          description: "Right ascension in degrees"
        },
        declination: %Schema{
          type: :number,
          format: :float,
          nullable: true,
          description: "Declination"
        },
        distance_parsecs: %Schema{
          type: :number,
          format: :float,
          nullable: true,
          description: "Distance in parsecs"
        },
        proper_motion_ra: %Schema{
          type: :number,
          format: :float,
          nullable: true,
          description: "Proper motion in RA"
        },
        proper_motion_dec: %Schema{
          type: :number,
          format: :float,
          nullable: true,
          description: "Proper motion in Dec"
        },
        radial_velocity: %Schema{
          type: :number,
          format: :float,
          nullable: true,
          description: "Radial velocity"
        },
        apparent_magnitude: %Schema{
          type: :number,
          format: :float,
          nullable: true,
          description: "Apparent magnitude"
        },
        absolute_magnitude: %Schema{
          type: :number,
          format: :float,
          nullable: true,
          description: "Absolute magnitude"
        },
        spectral_type: %Schema{type: :string, nullable: true, description: "Spectral type"},
        spectral_class: %Schema{type: :string, nullable: true, description: "Spectral class"},
        color_index: %Schema{
          type: :number,
          format: :float,
          nullable: true,
          description: "Color index"
        },
        x: %Schema{type: :number, format: :float, nullable: true, description: "X coordinate"},
        y: %Schema{type: :number, format: :float, nullable: true, description: "Y coordinate"},
        z: %Schema{type: :number, format: :float, nullable: true, description: "Z coordinate"},
        luminosity: %Schema{
          type: :number,
          format: :float,
          nullable: true,
          description: "Luminosity"
        },
        variable_type: %Schema{type: :string, nullable: true, description: "Variable type"},
        variable_min: %Schema{
          type: :number,
          format: :float,
          nullable: true,
          description: "Minimum variability"
        },
        variable_max: %Schema{
          type: :number,
          format: :float,
          nullable: true,
          description: "Maximum variability"
        },
        constellation: %Schema{type: :string, nullable: true, description: "Constellation"},
        star_system_id: %Schema{
          type: :integer,
          nullable: true,
          description: "Associated star system ID"
        }
      },
      required: ["id", "name", "is_primary"]
    })
  end

  # --------------------------------------------------------------------
  # Schema for the GET /stars/:id Request
  # --------------------------------------------------------------------
  defmodule GetStarRequest do
    @moduledoc "Request parameters for GET /stars/:id."
    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      title: "GetStarRequest",
      description: "Path parameters for retrieving a star",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Unique identifier for the star"}
      },
      required: ["id"]
    })
  end

  # --------------------------------------------------------------------
  # Schema for the GET /stars/:id Response
  # --------------------------------------------------------------------
  defmodule GetStarResponse do
    @moduledoc "Response schema for GET /stars/:id."
    require OpenApiSpex
    alias OpenApiSpex.Schema
    alias StarChartWeb.Schema.Star

    OpenApiSpex.schema(%{
      title: "GetStarResponse",
      description: "Response containing a star",
      type: :object,
      properties: %{
        data: Star
      },
      required: ["data"]
    })
  end
end
