import React, { Component } from "react";
import axios from "axios";

class BreachReport extends Component {
  state = {
    loading: false,
    error: false,
    breaches: false
  };

  componentDidMount() {
    this.fetchBreaches();
  }

  render() {
    const breaches = this.state.breaches;
    return (
      <div style={{ textAlign: "center", width: "600px", margin: "50px auto" }}>
        <h1>Breach Report</h1>
        <div>
          {this.state.loading ? (
            <p>Currently loading the data breaches.</p>
          ) : breaches ? (
            <div>
              <div>
                <h2>Here are some current data breaches for you</h2>
                <h3>{`${breaches[0].Title}`}</h3>
                Breached on: {`${breaches[0].BreachDate}`} <br />
                Accounts breached: {`${breaches[0].PwnCount}`} <br />
              </div>
              <p />
              <div>
                <h3>{`${breaches[1].Title}`}</h3>
                Breached on: {`${breaches[1].BreachDate}`} <br />
                Accounts breached: {`${breaches[1].PwnCount}`} <br />
              </div>
            </div>
          ) : (
            <p>There was an error loading the data breaches.</p>
          )}
        </div>
      </div>
    );
  }

  fetchBreaches = () => {
    this.setState({ loading: true });
    axios
      .get("https://haveibeenpwned.com/api/v2/breaches")
      .then(breaches => {
        var response = breaches.data;
        response
          .sort((a, b) => {
            return new Date(a.BreachDate) - new Date(b.BreachDate);
          })
          .reverse();
        this.setState({ loading: false, breaches: response });
      })
      .catch(error => {
        this.setState({ loading: false, error });
      });
  };
}

export default BreachReport;
