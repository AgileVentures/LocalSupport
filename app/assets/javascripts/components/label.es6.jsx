class Label extends React.Component {
  constructor () {
    super();
    this.handleClick = this.handleClick.bind(this);
    this.render = this.render.bind(this);
    this.state = {
      isOpen: false
    };
  }

  handleClick() {
    this.setState({
      isOpen: !this.state.isOpen
    });
  }

  renderLogin() {
    if (this.state.isOpen) {
      return (
        <div className='absolute bg-white border rounded py2 px2'>
          <label htmlFor='login'>Login:</label>
          <form id='login'>
            <label>Email Address</label>
            <input type='text' className='block col-12 mb1 field' />
            <label>Password</label>
            <input type='password' className='block col-12 mb1 field' />
            <label className='block col-12 mb2'>
              <input type='checkbox' />
              Remember Me
            </label>
            <button type='submit' className='btn btn-primary'>Sign In</button>
            <button type='reset' className='btn btn-primary black bg-gray'>Cancel</button>
          </form>
        </div>
      );
    }
  }

  render() {
    return (
      <div className='relative'>
        <a onClick={this.handleClick} className='btn py2 black muted'>Login</a>
        {this.renderLogin()}
      </div>
    );
  }
}

Label.propTypes = {
  label: React.PropTypes.string
};
