class Label extends React.Component {
  constructor () {
    super();
    this.handleOpenFormClick = this.handleOpenFormClick.bind(this);
    this.handleSignUpToggle = this.handleSignUpToggle.bind(this);
    this.render = this.render.bind(this);
    this.state = {
      isShowingForm: false,
      isShowingLogInForm: true
    };
  }

  handleOpenFormClick() {
    this.setState({
      isShowingForm: !this.state.isShowingForm
    });
  }

  handleSignUpToggle() {
    this.setState({
      isShowingLogInForm: !this.state.isShowingLogInForm
    });
  }

  renderLogInForm() {
    return (
      <form>
        <label>Email Address</label>
        <input type='text' className='block col-12 mb1 field' />
        <label>Password</label>
        <input type='password' className='block col-12 mb1 field' />
        <label className='block col-12 mb2'>
          <input type='checkbox' />
          Remember Me
        </label>
        <button type='submit' className='btn btn-primary'>Sign In</button>
        <a className='px1'>Forgot password?</a>
        <a onClick={this.handleSignUpToggle} className='block py2'>New organisation? Sign up</a>
      </form>
    );
  }

  renderSignUpForm() {
    return (
      <form>
        <label>Email Address</label>
        <input type='text' className='block col-12 mb1 field' />
        <label>Password</label>
        <input type='password' className='block col-12 mb1 field' />
        <label>Confirm Password</label>
        <input type='password' className='block col-12 mb1 field' />
        <button type='submit' className='btn btn-primary'>Sign Up</button>
        <a onClick={this.handleSignUpToggle} className='block py2'>Already a member? Log in</a>
      </form>
    );
  }

  renderForm() {
    if (this.state.isShowingForm) {
      return (
        <div className='absolute bg-white border rounded py2 px2'>
          {this.state.isShowingLogInForm ? this.renderLogInForm() : this.renderSignUpForm()}
        </div>
      );
    }
  }

  render() {
    return (
      <div className='relative'>
        <a onClick={this.handleOpenFormClick} className='btn py2 black muted'>Login</a>
        {this.renderForm()}
      </div>
    );
  }
}

Label.propTypes = {
  label: React.PropTypes.string
};
