# Star Chart

Welcome to Star Chart! Your guide to the stars.

The motivation for this project is to provide a developer-friendly API for exploring our galaxy. There are many sources for this data online, such as:

- The [HYG Database](https://astronexus.com/projects/hyg): a star catalog that combines data from Hipparcos, Yale Bright Star Catalog, and the Gliese catalog, providing information about stars' positions, magnitudes, and spectral types
- [NASA Exoplanet Archive](https://exoplanetarchive.ipac.caltech.edu/): An online astronomical exoplanet catalog and data service that collects and serves public data supporting the search for and characterization of exoplanets and their host stars

Star Chart aims to integrate these various data sources into a single REST API.

> [!IMPORTANT]
> This is a hobby project - data is not guaranteed to be accurate

Personal goals for this project:

- To learn more about our galaxy and how scientists create and use this information, and make this
- To experiment with AI coding workflows. Most of the code in this repo was written with the assistance of [aider.chat\(https://aider.chat/)

## Project Structure

- `./star_chart`: An Elixir Phoenix REST API application that provides information on star systems.
- `./types`: Typescript types that correspond to the REST API
- `./examples/navigator`: (coming soon) an interactive map built with React & Three.js

## Roadmap

### API

- [ ] Set up OpenAPI + Swagger UI for interactive API documentation
- [ ] Import & integrate data from the NASA Exoplanet archive
- [ ] Deploy the API to a public URL + set up with CDN
- [ ] Create an example React + Three.js app for charting routes
- [ ] ...much more to come!
