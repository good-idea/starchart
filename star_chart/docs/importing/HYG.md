# HYG Database Import Documentation

## Setup and Import Process

1. First, download and extract the HYG database by running the provided script:

   ```bash
   chmod +x star_chart/data/download_hyg.sh
   ./star_chart/data/download_hyg.sh
   ```

   This will download and extract the HYG database to `star_chart/data/hyg_v41.csv`

2. Import the data into your database using the mix task:
   ```bash
   mix star_chart.import_hyg star_chart/data/hyg_v41.csv
   ```

## Source Data Column Definitions

The HYG Database is a compilation of stellar data from multiple catalogs. The database is available as a CSV file with the following columns:

1. `id` - Unique identifier for the star in the database. This is a sequential number assigned by the HYG database.

2. `hip` - Hipparcos catalog number. The Hipparcos catalog was created from the European Space Agency's Hipparcos satellite observations (1989-1993) and contains precise position and brightness measurements for over 100,000 stars.

3. `hd` - Henry Draper catalog number. The HD catalog was published between 1918-1924 and was one of the first major catalogs to include stellar spectral classifications.

4. `hr` - Harvard Revised (Bright Star) catalog number. This catalog contains the brightest stars visible from Earth, typically those brighter than magnitude 6.5.

5. `gl` - Gliese catalog number. The Gliese catalog focuses on nearby stars, particularly those within 25 parsecs of Earth.

6. `bf` - Bayer/Flamsteed designation. A combination field that might contain either a Bayer letter (Greek letter designation within a constellation) or a Flamsteed number.

7. `proper` - Proper name of the star, if it has one (e.g., "Sirius", "Vega", "Proxima Centauri").

8. `ra` - Right Ascension, measured in hours (0 to 24). This is one of the two coordinates used to locate a star on the celestial sphere, similar to longitude on Earth.

9. `dec` - Declination, measured in degrees (-90 to +90). This is the second coordinate used to locate a star, similar to latitude on Earth.

10. `dist` - Distance from Earth measured in parsecs. One parsec is approximately 3.26 light-years.

11. `pmra` - Proper motion in Right Ascension, measured in milliarcseconds per year. This indicates how fast the star appears to be moving east/west across the sky.

12. `pmdec` - Proper motion in Declination, measured in milliarcseconds per year. This indicates how fast the star appears to be moving north/south across the sky.

13. `rv` - Radial Velocity in kilometers per second. A positive value means the star is moving away from Earth; a negative value means it's moving toward Earth.

14. `mag` - Apparent magnitude - how bright the star appears from Earth. Lower numbers indicate brighter stars. The brightest stars have negative magnitudes.

15. `absmag` - Absolute magnitude - how bright the star would appear if it were 10 parsecs away from Earth. This is a measure of the star's true brightness.

16. `spect` - Spectral type (e.g., "G2V" for our Sun). This classification system provides information about the star's temperature and size:

    - First letter (O, B, A, F, G, K, M) indicates temperature (hottest to coolest)
    - Number (0-9) provides finer temperature gradation
    - Roman numeral (I to V) indicates luminosity class (I = supergiant, V = main sequence)

    The first letter of this field is extracted to populate the `spectral_type_generic` field, which represents the main spectral class of the star.

17. `ci` - Color Index (B-V). The difference between the star's magnitude in blue light and visual (yellow) light. Larger values indicate redder (cooler) stars.

18. `x` - Cartesian X coordinate in parsecs from the Sun
19. `y` - Cartesian Y coordinate in parsecs from the Sun
20. `z` - Cartesian Z coordinate in parsecs from the Sun

21. `vx` - Space velocity X component in km/s. Space Velocity represents how fast and in what direction a star is actually moving through space relative to the Sun, measured in kilometers per second (km/s).
22. `vy` - Space velocity Y
23. `vz` - Space velocity Z

24. `rarad` - Right Ascension in radians. The right ascension is the angular distance of a star eastward from the vernal equinox, measured in hours, minutes, and seconds.
25. `decrad` - Declination in radians. The declination is the angular distance of a star northward or southward from the celestial equator, measured in degrees, minutes, and seconds.

26. `pmrarad` - Proper motion in Right Ascension in radians per year. Proper motion is the angular movement of a star across the sky, measured in radians per year.
27. `pmdecrad` - Proper motion in Declination in radians per year

28. `bayer` - Bayer designation (Greek letter) for the star within its constellation. The Bayer designation is a system of Greek letters assigned to stars in the northern hemisphere, based on their position in the constellation.
29. `flam` - Flamsteed number within its constellation. The Flamsteed number is a system of numbers assigned to stars in the northern hemisphere, based on their position in the constellation.

30. `con` - Standard 3-letter constellation abbreviation (e.g., "Ori" for Orion)

31. `comp` - Companion star flag. Indicates if this star is part of a multiple star system
32. `comp_primary` - ID of the primary star if this is a companion star

33. `base` - Base star name for computing additional star names

34. `lum` - Luminosity relative to the Sun. A value of 1.0 means the star has the same luminosity as our Sun.

35. `var` - Variable star type, if applicable. Indicates if and how the star's brightness changes over time.
36. `var_min` - Minimum magnitude for variable stars
37. `var_max` - Maximum magnitude for variable stars

## Data Quality Notes

- Not all stars will have values for all fields. Missing values are represented as empty fields in the CSV.
- The first row of the CSV contains column headers.
- The first entry (id=0) is typically the Sun, used as a reference point.
- Distances (dist) may be missing or uncertain for more distant stars.
- Proper motions (pmra, pmdec) and radial velocities (rv) may be missing for fainter or more distant stars.
