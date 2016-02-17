[cancel, coords, locationNumber, deposit, notes] = LocationMetadataEntry(EyeTypes.Right, SubjectTypes.Human, QuarterTypes.Unknown, 7, 7, 'importPath')


if ~isempty(coords)
                locationCoordsString = ['Location Coordinates: ', coordsIntoString(coords(1), coords(2))]
            else
                locationCoordsString = ['Location Coordinates: ', 'Unknown']
            end