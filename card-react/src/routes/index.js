import Home from '../components/pages/home'
import Board from '../components/pages/gameboard'
import { ROUTE_SITE_BOARD, ROUTE_SITE_ROOT } from '../data/constants/routes'

export const defaultRoute = [{
    path: ROUTE_SITE_ROOT,
    exact: true,
    name: "Home",
    component: Home
}];

export const InternalRoutes = [
    {
        path: ROUTE_SITE_BOARD,
        exact: true,
        name: "Board",
        component: Board
    }
]

