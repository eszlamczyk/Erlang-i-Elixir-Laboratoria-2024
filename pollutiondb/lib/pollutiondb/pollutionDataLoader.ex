defmodule PollutionDataLoader do
  defp parseline(line) do
    [dateTime, pollutionType, pollutionLevel, stationID, stationName, location] =
      String.split(line, ";")

    [longitude, latitude] = String.split(location, ",")

    stationID = String.to_integer(stationID)
    pollutionLevel = String.to_float(pollutionLevel)

    case DateTime.from_iso8601(dateTime) do
      {:ok, datetime, _offset} ->
        date = DateTime.to_date(datetime)
        time = DateTime.to_time(datetime) |> Time.truncate(:second)

        %{
          :date => date,
          :time => time,
          :longitude => longitude,
          :latitude => latitude,
          :stationID => stationID,
          :stationName => stationName,
          :pollutionType => pollutionType,
          :pollutionLevel => pollutionLevel
        }

      error -> error
    end
  end

  defp identifyStations(listOfMaps) do
    stations = Enum.uniq_by(listOfMaps, fn x -> x[:stationID] end)
    Enum.map(stations, fn x -> {"#{x.stationID} #{x.stationName}", x.longitude, x.latitude} end)
  end

  def loadFullData(dataPath) do
    fData =
      File.read!(dataPath)
      |> String.split("\n")
      |> Enum.filter(fn x -> x != "" end)
      |> Enum.map(fn x -> parseline(x) end)

    # getStations
    stations = identifyStations(fData)
    # setStations
    Enum.map(stations, fn {name, longitude,latitude} -> Pollutiondb.Station.add(name,longitude,latitude) end)
    # setData
    Enum.map(fData, fn x ->
         Pollutiondb.Reading.add("#{x.stationID} #{x.stationName}", x.date, x.time, x.pollutionType, x.pollutionLevel)
    end)

    :dataLoaded
  end
end