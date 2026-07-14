const cds = require ('@sap/cds')
class DataService extends cds.ApplicationService { init() {

  const { Flights } = cds.entities ('sap.capire.flights')
  const LOG = cds.log()

  this.on ('BookingCreated', async req => {
    const { flight, date, seats = [null] } = req.data
    const confirmed = await UPDATE (Flights, { flight_ID:flight, date })
      .set `occupied_seats = occupied_seats + ${seats.length}`
      .where `free_seats >= ${seats.length}`
    if (!confirmed) req.reject('Flight is fully booked')

    const { free_seats } = await SELECT('free_seats').from(Flights, { flight_ID:flight, date })
    LOG.info(`[${2}] Booking Confirmed: Change free seats to ${free_seats}`)
    this.emit('FlightsUpdated', { flight, date, free_seats })
  })

  this.on ('BookingDeleted', async (req) => {
    const { flight, date, seats = [null] } = req.data
    await UPDATE (Flights, { flight_ID:flight, date })
      .set `occupied_seats = occupied_seats - ${seats.length}`

    const { free_seats } = await SELECT('free_seats').from(Flights, { flight_ID:flight, date })
    this.emit('FlightsUpdated', { flight, date, free_seats })
  })

  return super.init()

}}
module.exports = DataService
