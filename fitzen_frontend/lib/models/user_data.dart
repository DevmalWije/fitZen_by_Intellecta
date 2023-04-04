class UserData {
  final int totalElapsedSeconds;
  final int totalBadPosturePercentage;
  final int score;
  final int goodPostureCount;
  final int badPostureCount;
  final String eyeStrainLevel;
  final int elapsedSeconds;

  UserData(this.totalElapsedSeconds, this.totalBadPosturePercentage, this.score,
      this.goodPostureCount, this.badPostureCount, this.eyeStrainLevel, this.elapsedSeconds);

  factory UserData.fromJson(Map json) {
    return UserData(
      json['totalElapsedSeconds'],
      json['totalBadPosturePercentage'],
      json['score'],
      json['goodPostureCount'],
      json['badPostureCount'],
      json['eyeStrainLevel'],
      json['elapsedSeconds'],
    );
  }

  String getTimeString(int elapsedSeconds){
    final hours = elapsedSeconds ~/ 3600;
    final minutes = (elapsedSeconds ~/ 60) % 60;
    final seconds = elapsedSeconds % 60;
    final timeString = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return timeString;
  }
}