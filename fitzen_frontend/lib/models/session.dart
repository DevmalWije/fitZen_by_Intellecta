class Session{
  int elapsedSeconds = 0;
  final int blinkCount;
  final int goodPostureCount;
  final int badPostureCount;
  
  Session(this.blinkCount, this.goodPostureCount, this.badPostureCount);
  
  factory Session.fromJson(Map json){
    return Session(json["total_blink_count"], json["good_posture_count"], json["bad_posture_count"]);
  }

}