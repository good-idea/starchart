/**
 * TypeScript definitions for the Star Chart API
 */

// Base Types

/**
 * Represents a star in the Star Chart system
 */
export type Star = {
  /** Unique identifier for the star */
  id: number
  /** Name of the star */
  name: string
  /** Proper name of the star, if it has one (e.g., "Sirius") */
  proper_name: string | null
  /** Indicates if the star is the primary star in its star system */
  is_primary: boolean
  /** Hipparcos catalog number */
  hip: number | null
  /** Henry Draper catalog number */
  hd: number | null
  /** Harvard Revised catalog number */
  hr: number | null
  /** Gliese catalog number */
  gl: string | null
  /** Bayer or Flamsteed designation */
  bayer_flamsteed: string | null
  /** Right Ascension in hours (0 to 24) */
  right_ascension: number | null
  /** Right Ascension in degrees (0 to 360) */
  right_ascension_degrees: number | null
  /** Declination in degrees (-90 to +90) */
  declination: number | null
  /** Distance from Earth measured in parsecs */
  distance_parsecs: number | null
  /** Proper motion in Right Ascension, measured in milliarcseconds per year */
  proper_motion_ra: number | null
  /** Proper motion in Declination, measured in milliarcseconds per year */
  proper_motion_dec: number | null
  /** Radial Velocity in kilometers per second */
  radial_velocity: number | null
  /** Apparent magnitude - how bright the star appears from Earth */
  apparent_magnitude: number | null
  /** Absolute magnitude - how bright the star would appear if it were 10 parsecs away */
  absolute_magnitude: number | null
  /** Spectral type (e.g., "G2V" for our Sun) */
  spectral_type: string | null
  /** Main spectral class of the star */
  spectral_class: SpectralClass
  /** Color Index (B-V) - difference between blue and visual magnitudes */
  color_index: number | null
  /** Cartesian X coordinate in parsecs from the Sun */
  x: number | null
  /** Cartesian Y coordinate in parsecs from the Sun */
  y: number | null
  /** Cartesian Z coordinate in parsecs from the Sun */
  z: number | null
  /** Luminosity relative to the Sun */
  luminosity: number | null
  /** Variable star type, if applicable */
  variable_type: string | null
  /** Minimum magnitude for variable stars */
  variable_min: number | null
  /** Maximum magnitude for variable stars */
  variable_max: number | null
  /** Standard 3-letter constellation abbreviation */
  constellation: string | null
  /** ID of the star system this star belongs to */
  star_system_id: number
}

/**
 * Valid spectral classes for stars
 */
export type SpectralClass =
  /** O-type: Extremely hot and bright blue stars (>30,000K) with strong UV emission */
  | 'O'
  /** B-type: Very hot blue-white stars (10,000-30,000K) with strong helium lines */
  | 'B'
  /** A-type: White or blue-white stars (7,500-10,000K) with strong hydrogen lines */
  | 'A'
  /** F-type: White to yellow-white stars (6,000-7,500K) */
  | 'F'
  /** G-type: Yellow stars like our Sun (5,200-6,000K) */
  | 'G'
  /** K-type: Orange stars (3,700-5,200K) with molecular bands appearing */
  | 'K'
  /** M-type: Red stars (2,400-3,700K) with strong molecular bands */
  | 'M'
  /** L-type: Very cool red/brown dwarfs (1,300-2,400K) with metal hydride lines */
  | 'L'
  /** T-type: Methane dwarfs (700-1,300K) with strong methane absorption */
  | 'T'
  /** Y-type: Ultra-cool brown dwarfs (<700K) with ammonia absorption */
  | 'Y'
  /** U-type: Unknown or unclassified spectral type */
  | 'U'

/**
 * Represents a star system in the Star Chart system
 */
export type StarSystem = {
  /** Unique identifier for the star system */
  id: number
  /** Name of the star system */
  name: string
  /** Total number of stars in this system */
  star_count?: number
  /** Details about the primary star in the system */
  primary_star?: Star
  /** Array of all non-primary stars in the system */
  secondary_stars?: Star[]
}

/**
 * Distance information between star systems
 */
export type Distance = {
  /** Distance in parsecs */
  parsecs: number
  /** Distance in light years */
  light_years: number
}

/**
 * Represents a nearby star system with distance information
 */
export type NearbyStarSystem = {
  /** The star system details */
  system: StarSystem
  /** The distance from the origin star system */
  distance: Distance
}

// Pagination and Metadata

/**
 * Pagination metadata included in list responses
 */
export type PaginationMeta = {
  /** Current page number */
  page: number
  /** Number of items per page */
  page_size: number
  /** Total number of items available */
  total_entries: number
  /** Total number of pages available */
  total_pages: number
}

// API Response Types

/**
 * Response format for listing star systems
 */
export type StarSystemsListResponse = {
  /** Array of star systems */
  data: StarSystem[]
  /** Pagination metadata */
  meta: PaginationMeta
}

/**
 * Response format for a single star system
 */
export type StarSystemResponse = {
  /** The star system details */
  data: StarSystem
}

/**
 * Response format for listing stars
 */
export type StarListResponse = {
  /** Array of stars */
  data: Star[]
}

/**
 * Response format for a single star
 */
export type StarResponse = {
  /** The star details */
  data: Star
}

/**
 * Response format for nearby star systems
 */
export type NearbyStarSystemsResponse = {
  /** Array of nearby star systems with distance information */
  data: NearbyStarSystem[]
  /** Pagination metadata */
  meta: PaginationMeta
}

/**
 * Error response format
 */
export type ErrorResponse = {
  errors: {
    detail: string
  }
}

// API Request Parameter Types

export type StarSystemsListParams = {
  /** The page number to retrieve (default: 1, min: 1) */
  page?: number
  /** Number of items per page (default: 100, min: 1, max: 200) */
  page_size?: number
  /** Filter star systems by spectral class */
  spectral_class?: SpectralClass
  /** Filter for star systems with at least this many stars */
  min_stars?: number
  /** Filter for star systems with at most this many stars */
  max_stars?: number
}

export type NearbyStarSystemsParams = StarSystemsListParams & {
  /** Maximum distance in light years (default: 25.0, min: 0.1, max: 100) */
  distance?: number
}

export type StarSystemParams = {
  id: number
}

export type StarSystemStarsParams = {
  star_system_id: number
}

export type StarParams = {
  /** ID of the star to retrieve */
  id: number
}
