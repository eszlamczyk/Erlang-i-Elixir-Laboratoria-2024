defmodule Pollutiondb.Reading do
  use Ecto.Schema

  schema "readings" do
    field :date, :date
    field :time, :time
    field :type, :string
    field :value, :float
    belongs_to :station, Pollutiondb.Station
  end

  def add_now(station,type,value) do
    case Pollutiondb.Repo.get(Pollutiondb.Station, station.id) do
      nil ->
        {:error, "Station does not exist"}

      existing_station ->
        %Pollutiondb.Reading{
          date: Date.utc_today,
          time: Time.utc_now,
          type: type,
          value: value,
          station_id: existing_station.id
        }
        |> Pollutiondb.Repo.insert()
    end
  end

  def add(stationName, date, time, type, value) do
    case Pollutiondb.Repo.get_by(Pollutiondb.Station, name: stationName) do
      nil ->
        {:error, "Station does not exist"}

      existing_station ->
        %Pollutiondb.Reading{
          date: date,
          time: time,
          type: type,
          value: value,
          station_id: existing_station.id
        }
        |> Pollutiondb.Repo.insert()
    end
  end
end