const cds = require ('@sap/cds')
class DataService extends cds.ApplicationService { init() {

  const { Flights } = cds.entities ('sap.capire.flights')

  this.on ('BookingCreated', async req => {
    const { flight, date, seats = [null] } = req.data
    await UPDATE (Flights, { flight_ID:flight, date }) 
    .set `occupied_seats = occupied_seats + ${seats.length}`
  })

  this.on ('BookingDeleted', async (req) => {
    const { flight, date, seats = [null] } = req.data
    await UPDATE (Flights, { flight_ID:flight, date }) 
    .set `occupied_seats = occupied_seats - ${seats.length}`
  })

  return super.init()

}}
module.exports = DataService
