import Swal from "sweetalert2";

export function joinRoom (value) {
    const roomId = value;
    const lobbyChannel = 'dungeonmayhem-lobby--' + roomId;

    // Check the number of people in the channel
    this.pubnub.hereNow({
      channels: [lobbyChannel],
    }).then((response) => {
      if (response.totalOccupancy < 4) {
        this.pubnub.subscribe({
          channels: [this.lobbyChannel],
          withPresence: true
        });

        

        this.pubnub.publish({
          message: {
            notRoomCreator: true,
          },
          channel: this.lobbyChannel
        });
      }
      else {
        // Game in progress
        Swal.fire({
          position: 'top',
          allowOutsideClick: false,
          title: 'Error',
          text: 'Game in progress. Try another room.',
          width: 275,
          padding: '0.7em',
          customClass: {
            heightAuto: false,
            title: 'title-class',
            popup: 'popup-class',
            confirmButton: 'button-class'
          }
        })
      }
    }).catch((error) => {
      console.log(error);
    });
  }