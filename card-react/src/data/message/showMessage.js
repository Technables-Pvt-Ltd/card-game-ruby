import { toast } from 'react-toastify'
import { TOAST_SUCCESS } from '../constants/toastmessagetype';

export function ShowMessage(type, msg) {
    var option = {
        position: toast.POSITION.TOP_RIGHT
    };

    switch (type) {
        case TOAST_SUCCESS:
            toast.success(msg, option);
            break;
        default:

            break;
    }
}