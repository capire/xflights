const cds = require ('@sap/cds')
class DataService extends cds.ApplicationService { async init() {

  const messaging = await cds.connect.to ('messaging')

  const { Flights } = cds.entities ('sap.capire.flights')

  this.on ('BookingCreated', async req => {
    const { flight, date, seats = [null] } = req.data
    const confirmed = await UPDATE (Flights, { flight_ID:flight, date })
      .set `occupied_seats = occupied_seats + ${seats.length}`
      .where `free_seats >= ${seats.length}`
    if (!confirmed) req.reject('Flight is fully booked')

    // messages can overtake each other -> don't propagate free seats in payload
    messaging.emit('FlightUpdated', { flight_ID:flight, date })
  })

  this.on ('BookingDeleted', async (req) => {
    const { flight, date, seats = [null] } = req.data
    await UPDATE (Flights, { flight_ID:flight, date })
      .set `occupied_seats = occupied_seats - ${seats.length}`

    // messages can overtake each other -> don't propagate free seats in payload
    messaging.emit('FlightUpdated', { flight_ID:flight, date })
  })

  return super.init()

}}
module.exports = DataService
