class SnowModelClass {
  TopLift? topLift;
  TopLift? midLift;
  TopLift? botLift;

  SnowModelClass({this.topLift, this.midLift, this.botLift,});

  SnowModelClass.fromJson(Map<String, dynamic> json) {
    topLift = json['topLift'] != null ? TopLift.fromJson(json['topLift']) : null;
    midLift = json['midLift'] != null ? TopLift.fromJson(json['midLift']) : null;
    botLift = json['botLift'] != null ? TopLift.fromJson(json['botLift']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.topLift != null) {
      data['topLift'] = this.topLift!.toJson();
    }
    if (this.midLift != null) {
      data['midLift'] = this.midLift!.toJson();
    }
    if (this.botLift != null) {
      data['botLift'] = this.botLift!.toJson();
    }

    return data;
  }
}

class TopLift {
  List<Forecast5Day>? forecast5Day;
  String? summary3Day;
  String? summaryDays4To6;

  TopLift({this.forecast5Day, this.summary3Day, this.summaryDays4To6});

  TopLift.fromJson(Map<String, dynamic> json) {
    if (json['forecast5Day'] != null) {
      forecast5Day = <Forecast5Day>[];
      json['forecast5Day'].forEach((v) {
        forecast5Day!.add(Forecast5Day.fromJson(v));
      });
    }
    summary3Day = json['summary3Day'];
    summaryDays4To6 = json['summaryDays4To6'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.forecast5Day != null) {
      data['forecast5Day'] = this.forecast5Day!.map((v) => v.toJson()).toList();
    }
    data['summary3Day'] = this.summary3Day;
    data['summaryDays4To6'] = this.summaryDays4To6;
    return data;
  }

  List<double> getSnowData() {
    List<double> snowData = [];
    for (int i = 0; i < forecast5Day!.length; i++) {
      if (forecast5Day![i].pm != null && forecast5Day![i].pm!.snow != null) {
        // Try to parse the snow value as a double, default to 0.0 if parsing fails
        try {
          double snowValue = double.parse(forecast5Day![i].pm!.snow!);
          snowData.add(snowValue);
        } catch (e) {
          // Handle parsing errors, non-numeric values, or other scenarios
          // You might want to log the error or take other appropriate actions
          snowData.add(0.0); // Default to 0.0 in case of errors
        }
      } else {
        // Handle null values or incomplete data
        snowData.add(0.0);
      }
    }
    return snowData;
  }
}


class Forecast5Day {
  String? dayOfWeek;
  Am? am;
  Am? pm;
  Am? night;

  Forecast5Day({this.dayOfWeek, this.am, this.pm, this.night});

  Forecast5Day.fromJson(Map<String, dynamic> json) {
    dayOfWeek = json['dayOfWeek'];
    am = json['am'] != null ? Am.fromJson(json['am']) : Am(); // Create an empty Am object if 'am' is null
    pm = json['pm'] != null ? Am.fromJson(json['pm']) : Am();
    night = json['night'] != null ? Am.fromJson(json['night']) : Am();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dayOfWeek'] = this.dayOfWeek;
    if (this.am != null) {
      data['am'] = this.am!.toJson();
    }
    if (this.pm != null) {
      data['pm'] = this.pm!.toJson();
    }
    if (this.night != null) {
      data['night'] = this.night!.toJson();
    }
    return data;
  }
}

class Am {
  String? summary;
  String? windSpeed;
  String? windDirection;
  String? snow;
  String? rain;
  String? maxTemp;
  String? minTemp;
  String? windChill;
  String? humidity;
  String? freezeLevel;

  Am(
      {this.summary,
        this.windSpeed,
        this.windDirection,
        this.snow,
        this.rain,
        this.maxTemp,
        this.minTemp,
        this.windChill,
        this.humidity,
        this.freezeLevel});

  Am.fromJson(Map<String, dynamic> json) {
    summary = json['summary'];
    windSpeed = json['windSpeed'];
    windDirection = json['windDirection'];
    snow = json['snow'];
    rain = json['rain'];
    maxTemp = json['maxTemp'];
    minTemp = json['minTemp'];
    windChill = json['windChill'];
    humidity = json['humidity'];
    freezeLevel = json['freezeLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['summary'] = this.summary;
    data['windSpeed'] = this.windSpeed;
    data['windDirection'] = this.windDirection;
    data['snow'] = this.snow;
    data['rain'] = this.rain;
    data['maxTemp'] = this.maxTemp;
    data['minTemp'] = this.minTemp;
    data['windChill'] = this.windChill;
    data['humidity'] = this.humidity;
    data['freezeLevel'] = this.freezeLevel;
    return data;
  }
}

class BasicInfo {
  String? region;
  String? name;
  String? url;
  String? topLiftElevation;
  String? midLiftElevation;
  String? botLiftElevation;
  String? lat;
  String? lon;

  BasicInfo(
      {this.region,
        this.name,
        this.url,
        this.topLiftElevation,
        this.midLiftElevation,
        this.botLiftElevation,
        this.lat,
        this.lon});

  BasicInfo.fromJson(Map<String, dynamic> json) {
    region = json['region'];
    name = json['name'];
    url = json['url'];
    topLiftElevation = json['topLiftElevation'];
    midLiftElevation = json['midLiftElevation'];
    botLiftElevation = json['botLiftElevation'];
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['region'] = this.region;
    data['name'] = this.name;
    data['url'] = this.url;
    data['topLiftElevation'] = this.topLiftElevation;
    data['midLiftElevation'] = this.midLiftElevation;
    data['botLiftElevation'] = this.botLiftElevation;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}
