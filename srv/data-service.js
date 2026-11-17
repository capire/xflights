const cds = require ('@sap/cds')
class DataService extends cds.ApplicationService { init() {

  const { Flights, Bookings } = cds.entities ('sap.capire.flights')

  this.on ('reserveSeats', async req => {
    const { flight, date, seats = [null] } = req.data
    const confirmed = await UPDATE (Flights, { flight_ID: flight, date })
      .set `occupied_seats = occupied_seats + ${seats.length}`
      .where `free_seats >= ${seats.length}`
    if (!confirmed) req.reject('Flight is fully booked')
    this.emit('FlightsUpdated', { flight, date })
  })

  this.on ('releaseSeats', async (req) => {
    const { flight, date, seats = [null] } = req.data
    await UPDATE (Flights, { flight_ID: flight, date })
      .set `occupied_seats = occupied_seats - ${seats.length}`
    this.emit('FlightsUpdated', { flight, date })
  })

  this.on ('bookFlight', async req => {
    const { passenger, flight, date, seats = [null] } = req.data
    await this.reserveSeats ({ flight, date, seats })
    const [{ ID: bookingId }] = await INSERT.into (Bookings) .entries ({
      flight: { flight_ID: flight, date },
      passenger,
      seats
    })
    const { total, currency } = await SELECT.one `
      flight.price * ${seats.length} as total,
      flight.currency.code as currency
    `.from (Bookings, bookingId)
    return { bookingId, total, currency }
  })

  this.on ('cancelBooking', async req => {
    const { bookingId } = req.data
    const booking = await SELECT.one.from (Bookings, bookingId)
      || req.reject (404, `Booking ${bookingId} not found`)
    const { flight_ID, flight_date, seats } = booking
    await this.releaseSeats({ flight: flight_ID, date: flight_date, seats })
    await UPDATE (Bookings, bookingId).set({ status:'X' })
  })

  return super.init()

}}
module.exports = DataService
