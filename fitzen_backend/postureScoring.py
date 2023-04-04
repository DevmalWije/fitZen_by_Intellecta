def calculate_posture_score(good_posture_count, bad_posture_count, session_duration):
    """
    Calculates the posture score based on the count of good and bad posture.

    Args:
        good_posture_count (int): The count of good posture detections.
        bad_posture_count (int): The count of bad posture detections.
        session_duration (int): The total duration of the session, in minutes.

    Returns:
        int: The posture score, based on the count and frequency of good and bad posture.
    """

    # Calculate the total posture count
    posture_count = good_posture_count + bad_posture_count

    # Calculate the percentage of time spent in good posture
    good_posture_percentage = good_posture_count / posture_count * 100

    # Calculate the percentage of time spent in bad posture
    bad_posture_percentage = bad_posture_count / posture_count * 100

    # Calculate the posture score based on the count and frequency of good and bad posture
    posture_score = good_posture_count - \
        bad_posture_count + 5 * (good_posture_count // 30)

    # Return the posture score
    return int(good_posture_count), int(bad_posture_count)
