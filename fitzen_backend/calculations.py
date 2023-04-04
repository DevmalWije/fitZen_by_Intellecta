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

    # Check if the passed parameters are greater than zero
    if good_posture_count <= 0 or bad_posture_count <= 0 or session_duration <= 0:
        raise ValueError(
            "good_posture_count, bad_posture_count, and session_duration must be greater than zero")

    # Calculate the total posture count
    posture_count = good_posture_count + bad_posture_count

    # Calculate the percentage of time spent in good posture
    good_posture_percentage = good_posture_count / posture_count * 100

    # Calculate the percentage of time spent in bad posture
    bad_posture_percentage = bad_posture_count / posture_count * 100

    # Calculate the posture score based on the count and frequency of good and bad posture
    posture_score = good_posture_count - \
        bad_posture_count + 5 * (good_posture_count // 30)

    # Adjust the posture score to be on the same scale as the blink score
    posture_score = posture_score - 3 + 5 * (posture_score // 6)

    # Return the posture score
    return posture_score


def calculate_blink_score(blink_count, session_duration):
    """
    Calculates the blink score based on the blink count and session duration.

    Args:
        blink_count (int): The number of times the user has blinked during the session.
        session_duration (int): The total duration of the session, in minutes.

    Returns:
        int: The blink score, based on the count and frequency of blinks.
    """

    # Check if the passed parameters are greater than zero
    if blink_count <= 0 or session_duration <= 0:
        raise ValueError(
            "blink_count and session_duration must be greater than zero")

    # Calculate the blink rate (blinks per minute)
    blink_rate = blink_count / session_duration

    # Assign a score to the user's blinking behavior based on the blink rate
    if blink_rate >= 20:
        blink_score = 10
    elif blink_rate >= 15:
        blink_score = 7
    elif blink_rate >= 10:
        blink_score = 5
    else:
        blink_score = 2

    # Adjust the blink score to be on the same scale as the posture score
    blink_score = blink_score - 3 + 5 * (blink_score // 6)

    return blink_score


def calculate_posture_percentage(past_good_postures, past_bad_postures, current_good_postures, current_bad_postures):
    """
    Calculates the percentage of good and bad postures based on the total number of good and bad postures from all past sessions and the current session.

    Args:
        past_good_postures (int): The total number of good postures detected in all past sessions.
        past_bad_postures (int): The total number of bad postures detected in all past sessions.
        current_good_postures (int): The total number of good postures detected in the current session.
        current_bad_postures (int): The total number of bad postures detected in the current session.

    Returns:
        tuple: A tuple containing the percentage of good postures and the percentage of bad postures.
    """

    # Calculate the total number of good and bad postures
    total_good_postures = past_good_postures + current_good_postures
    total_bad_postures = past_bad_postures + current_bad_postures
    total_postures = total_good_postures + total_bad_postures

    # Calculate the percentage of good and bad postures
    good_posture_percentage = total_good_postures / total_postures * 100
    bad_posture_percentage = total_bad_postures / total_postures * 100

    # Return the percentages as a tuple
    return (good_posture_percentage, bad_posture_percentage)
    # # Extract the first value in the tuple and assign it to a new variable
    # good_posture_percentage = posture_percentages[0]
