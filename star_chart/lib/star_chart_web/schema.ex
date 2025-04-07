defmodule StarChartWeb.Schema do
  @moduledoc """
  OpenAPI schemas for the Star Chart API.
  """

  # --------------------------------------------------------------------
  # Shared parameters
  # --------------------------------------------------------------------
  defmodule Parameters do
    def spectral_class do
      %OpenApiSpex.Schema{
        enum: [
          "O",
          "B",
          "A",
          "F",
          "G",
          "K",
          "M",
          "L",
          "T",
          "Y",
          "U"
        ],
        type: :string
      }
    end
  end

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
  # Schema for a Star System
  # --------------------------------------------------------------------

  defmodule StarSystem do
    @moduledoc "Represents a Star System"
    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      title: "Star System",
      description: "A star system",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Unique identifier for the star system"},
        name: %Schema{type: :string, description: "Name of the star system"},
        star_count: %Schema{
          type: :integer,
          description: "Total number of stars in the system"
        },
        primary_star: Star,
        secondary_stars: %Schema{
          type: :array,
          description: "List of secondary stars in the system",
          items: Star
        }
      },
      required: ["id", "name"]
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

  # --------------------------------------------------------------------
  # Schema for the GET /star_systems Request
  # --------------------------------------------------------------------
  defmodule ListStarSystemsRequest do
    @moduledoc "Query parameters for GET /star_systems."
    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      title: "ListStarSystemsRequest",
      description: "Query parameters for listing star systems",
      type: :object,
      properties: %{
        page: %Schema{type: :integer, description: "Page number", default: 1, minimum: 1},
        page_size: %Schema{
          type: :integer,
          description: "Number of items per page",
          default: 100,
          minimum: 1,
          maximum: 200
        },
        spectral_class: %Schema{
          type: :string,
          description: "Filter by spectral class",
          pattern: "^[OBAFGKMLTY]$|^U$"
        },
        min_stars: %Schema{type: :integer, description: "Minimum number of stars", minimum: 1},
        max_stars: %Schema{type: :integer, description: "Maximum number of stars", minimum: 1}
      }
    })
  end

  # --------------------------------------------------------------------
  # Schema for the GET /star_systems Response
  # --------------------------------------------------------------------
  defmodule ListStarSystemsResponse do
    @moduledoc "Response schema for GET /star_systems."
    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      title: "ListStarSystemsResponse",
      description: "Response containing a list of star systems along with pagination metadata",
      type: :object,
      properties: %{
        data: %Schema{
          type: :array,
          description: "List of star systems",
          items: %Schema{
            type: :object,
            properties: %{
              id: %Schema{type: :integer, description: "Unique identifier for the star system"},
              name: %Schema{type: :string, description: "Name of the star system"},
              star_count: %Schema{
                type: :integer,
                description: "Total number of stars in the system"
              },
              primary_star: Star,
              secondary_stars: %Schema{
                type: :array,
                description: "List of secondary stars in the system",
                items: Star
              }
            },
            required: ["id", "name"]
          }
        },
        meta: %Schema{
          type: :object,
          description: "Pagination metadata for the results",
          properties: %{
            page: %Schema{type: :integer, description: "Current page number"},
            page_size: %Schema{type: :integer, description: "Number of items per page"},
            total_entries: %Schema{type: :integer, description: "Total number of star systems"},
            total_pages: %Schema{type: :integer, description: "Total number of pages available"}
          },
          required: ["page", "page_size", "total_entries", "total_pages"]
        }
      },
      required: ["data", "meta"]
    })
  end

  # --------------------------------------------------------------------
  # Schema for the GET /star_systems/:id Request
  # --------------------------------------------------------------------
  defmodule GetStarSystemRequest do
    @moduledoc "Request parameters for GET /star_systems/:id."
    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      title: "GetStarSystemRequest",
      description: "Path parameters for retrieving a star system",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Unique identifier for the star system"}
      },
      required: ["id"]
    })
  end

  # --------------------------------------------------------------------
  # Schema for the GET /star_systems/:id Response
  # --------------------------------------------------------------------
  defmodule GetStarSystemResponse do
    @moduledoc "Response schema for GET /star_systems/:id."
    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      title: "GetStarSystemResponse",
      description: "Response containing a star system",
      type: :object,
      properties: %{
        data: StarSystem
      },
      required: ["data"]
    })
  end

  # --------------------------------------------------------------------
  # Schema for the GET /star_systems/:origin_id/nearby Request
  # --------------------------------------------------------------------
  defmodule NearbyStarSystemsRequest do
    @moduledoc "Request parameters for GET /star_systems/:origin_id/nearby."
    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      title: "NearbyStarSystemsRequest",
      description: "Path and query parameters for retrieving nearby star systems",
      type: :object,
      properties: %{
        origin_id: %Schema{
          type: :integer,
          description: "Origin star system ID"
        },
        distance: %Schema{
          type: :number,
          format: :float,
          description: "Maximum distance in light years",
          default: 25.0,
          minimum: 0.1,
          maximum: 100.0
        },
        page: %Schema{
          type: :integer,
          description: "Page number",
          default: 1,
          minimum: 1
        },
        page_size: %Schema{
          type: :integer,
          description: "Number of items per page",
          default: 100,
          minimum: 1,
          maximum: 200
        },
        spectral_class: %Schema{
          type: :string,
          description: "Filter by spectral class",
          enum: ["O", "B", "A", "F", "G", "K", "M", "L", "T", "Y", "U"]
        },
        min_stars: %Schema{
          type: :integer,
          description: "Minimum number of stars",
          minimum: 1
        },
        max_stars: %Schema{
          type: :integer,
          description: "Maximum number of stars",
          minimum: 1
        }
      },
      required: ["origin_id"]
    })
  end

  # --------------------------------------------------------------------
  # Schema for the GET /star_systems/:origin_id/nearby Response
  # --------------------------------------------------------------------
  defmodule NearbyStarSystemsResponse do
    @moduledoc "Response schema for GET /star_systems/:origin_id/nearby."
    require OpenApiSpex
    alias OpenApiSpex.Schema

    OpenApiSpex.schema(%{
      title: "NearbyStarSystemsResponse",
      description: "Response containing a list of nearby star systems with distance information.",
      type: :object,
      properties: %{
        data: %Schema{
          type: :array,
          description: "List of nearby star systems with distance information",
          items: %Schema{
            type: :object,
            properties: %{
              system: %Schema{
                title: "StarSystem",
                description: "A star system object",
                type: :object,
                properties: %{
                  id: %Schema{
                    type: :integer,
                    description: "Unique identifier for the star system"
                  },
                  name: %Schema{type: :string, description: "Name of the star system"},
                  star_count: %Schema{
                    type: :integer,
                    description: "Total number of stars in the system"
                  }
                },
                required: ["id", "name"]
              },
              distance: %Schema{
                type: :object,
                description: "Distance information",
                properties: %{
                  parsecs: %Schema{
                    type: :number,
                    format: :float,
                    description: "Distance in parsecs"
                  },
                  light_years: %Schema{
                    type: :number,
                    format: :float,
                    description: "Distance in light years"
                  }
                },
                required: ["parsecs", "light_years"]
              }
            },
            required: ["system", "distance"]
          }
        },
        meta: %Schema{
          type: :object,
          description: "Pagination metadata for the results",
          properties: %{
            page: %Schema{type: :integer, description: "Current page number"},
            page_size: %Schema{type: :integer, description: "Number of items per page"},
            total_entries: %Schema{type: :integer, description: "Total number of star systems"},
            total_pages: %Schema{type: :integer, description: "Total number of pages available"}
          },
          required: ["page", "page_size", "total_entries", "total_pages"]
        }
      },
      required: ["data", "meta"]
    })
  end
end
