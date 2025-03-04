# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     StarChart.Repo.insert!(%StarChart.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Check if HYG data file exists
hyg_file_path = Path.join([File.cwd!(), "data", "hyg_v41.csv"])

if File.exists?(hyg_file_path) do
  IO.puts("Found HYG database file at #{hyg_file_path}")
  IO.puts("Importing HYG database...")
  
  # Run the import task
  Mix.Task.run("star_chart.import_hyg", [hyg_file_path])
  
  IO.puts("HYG database import completed!")
else
  IO.puts("""
  HYG database file not found at #{hyg_file_path}
  
  To import star data, please download the HYG database first:
  
  1. Run: chmod +x data/download_hyg.sh
  2. Run: ./data/download_hyg.sh
  3. Then run this seed script again
  """)
end
