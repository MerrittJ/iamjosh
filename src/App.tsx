import "./App.css";
import styled from "styled-components";

const Header = styled.h1`
  font-size: 3.2em;
  line-height: 1.1;
`;

const App = () => {
  return (
    <div className="App">
      <div></div>
      <Header>I am Josh</Header>
    </div>
  );
};

export default App;
