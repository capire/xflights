const cds = require('@sap/cds')
const service = 'sap.capire.flights.FlightsService'
// The below are dummy handlers for testing with mocked service only
// This will not be required with upcomming cds v10.1 any longer
require('@sap/cds').on(`serving:${service}`, srv => {
  if (srv.mocked) {
    srv.on ('reserveSeats', ()=>{})
    srv.on ('releaseSeats', ()=>{})
    srv.on ('bookFlight', async (req)=>{
      // Just a dummy implementation for mocked service
      const { flight, date, seats = [null] } = req.data
      const { total, currency } = await SELECT.one `
        price * ${seats.length} as total,
        currency.code as currency
      `.from (`${service}.Flights`, { ID: flight, date })
      return { bookingId: cds.utils.uuid(), total, currency }
    })
    srv.on ('cancelBooking', ()=>{})
  }
})
